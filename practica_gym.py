# -*- coding: utf-8 -*-
"""
Q-learning + comparativa planificador
Genera un DataFrame con métricas por problema (tamaño)
"""

import random
from typing import Any, Dict, List, Optional
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pddlgym
import itertools

# ------------------------------------------------------------
# ENV
# ------------------------------------------------------------
def make_env(domain: str = "PDDLEnv<Domain>-v0", problem_idx: int = 0) -> Any:
    env = pddlgym.make(domain)

    # Diagnóstico: cuántos problemas hay realmente
    n_probs = len(getattr(env, "problems", []))
    if n_probs == 0:
        raise RuntimeError(
            f"El entorno {domain} no tiene lista de problemas (env.problems vacío). "
            "Revisa el registro del entorno y los ficheros PDDL."
        )

    if problem_idx < 0 or problem_idx >= n_probs:
        raise IndexError(
            f"problem_idx={problem_idx} fuera de rango para {domain}. "
            f"Problemas disponibles: {n_probs} (índices válidos 0..{n_probs-1})."
        )

    env.fix_problem_index(problem_idx)
    return env

# ------------------------------------------------------------
# Q-LEARNING
# ------------------------------------------------------------
def run_q_learning(
    env: Any = None,
    total_episodes: int = 3000,
    learning_rate: float = 0.2,
    max_steps: int = 2000,
    gamma: float = 0.99,
    epsilon_start: float = 1.0,
    epsilon_min: float = 0.01,
    epsilon_decay: float = 0.995,
    conv_delta_threshold: float = 1e-5,
    conv_window: int = 30,
    conv_min_episodes: int = 50,
    early_stop_on_convergence: bool = True,
    seed: Optional[int] = 0,
) -> Dict[str, Any]:
    
    if seed is not None:
        random.seed(seed)
        np.random.seed(seed)

    if env is None:
        env = make_env()

    state, _ = env.reset()
    _ = env.action_space.all_ground_literals(state)
    all_actions = list(env.action_space._all_ground_literals)
    n_actions = len(all_actions)
    action_to_idx = {a: i for i, a in enumerate(all_actions)}

    vistos: List[Any] = [state]
    q_table = np.zeros((1, n_actions), dtype=float)

    episode_rewards: List[float] = []
    eps_history: List[float] = []
    deltas: List[float] = []

    epsilon = float(epsilon_start)
    converged_episode_exact = None

    for episode in range(total_episodes):
        state, _ = env.reset()
        if state not in vistos:
            vistos.append(state)
            q_table = np.vstack([q_table, np.zeros((1, n_actions))])

        total_reward = 0.0
        max_abs_update_this_episode = 0.0

        for _step in range(max_steps):
            applicable_actions = list(env.action_space.all_ground_literals(state))
            if not applicable_actions:
                break

            applicable_idxs = [action_to_idx[a] for a in applicable_actions]
            s_idx = vistos.index(state)

            if random.random() > epsilon:
                q_vals = q_table[s_idx, applicable_idxs]
                best_local = int(np.argmax(q_vals))
                action = applicable_actions[best_local]
                a_idx = applicable_idxs[best_local]
            else:
                action = random.choice(applicable_actions)
                a_idx = action_to_idx[action]

            new_state, reward, done, truncated, _info = env.step(action)
            total_reward += float(reward)

            if new_state not in vistos:
                vistos.append(new_state)
                q_table = np.vstack([q_table, np.zeros((1, n_actions))])

            ns_idx = vistos.index(new_state)
            next_actions = list(env.action_space.all_ground_literals(new_state))
            next_idxs = [action_to_idx[a] for a in next_actions]
            best_next_q = np.max(q_table[ns_idx, next_idxs]) if next_idxs else 0.0

            old_q = q_table[s_idx, a_idx]
            q_table[s_idx, a_idx] += learning_rate * ((reward + gamma * best_next_q) - old_q)
            delta = abs(q_table[s_idx, a_idx] - old_q)
            max_abs_update_this_episode = max(max_abs_update_this_episode, delta)

            state = new_state
            if done or truncated:
                break

        epsilon = max(epsilon_min, epsilon * epsilon_decay)
        episode_rewards.append(total_reward)
        eps_history.append(epsilon)
        deltas.append(max_abs_update_this_episode)

        if converged_episode_exact is None and (episode + 1) >= conv_min_episodes and len(deltas) >= conv_window:
            window = deltas[-conv_window:]
            if all(d < conv_delta_threshold for d in window):
                converged_episode_exact = episode - conv_window + 2
                if early_stop_on_convergence:
                    break

    return {
        "q_table": q_table,
        "vistos": vistos,
        "episode_rewards": episode_rewards,
        "eps_history": eps_history,
        "deltas": deltas,
        "converged_episode_exact": converged_episode_exact,
        "q_shape": q_table.shape,
        "n_actions": n_actions,
    }

# ------------------------------------------------------------
# PLANIFICADOR SIMULADO
# ------------------------------------------------------------
def run_planner(problem_idx: int) -> int:
    """
    Ejemplo: retorna coste/longitud del plan.
    Reemplazar con tu planificador real.
    """
    # Simulación: mientras mayor problem_idx, más largo el plan
    return 10 + 5 * problem_idx

# ------------------------------------------------------------
# MAIN
# ------------------------------------------------------------
def episodes_to_max_and_max_return(episode_rewards, smooth_window: int = 1):
    """
    Devuelve:
      - ep_to_max: episodio (1-indexado) donde se alcanza el máximo
      - max_ret: valor máximo del return
    Si smooth_window > 1 usa media móvil para encontrar el episodio del máximo.
    """
    if not episode_rewards:
        return None, None

    r = np.asarray(episode_rewards, dtype=float)

    if smooth_window and smooth_window > 1 and len(r) >= smooth_window:
        kernel = np.ones(smooth_window) / smooth_window
        r_smooth = np.convolve(r, kernel, mode="valid")
        i = int(np.argmax(r_smooth))
        # el índice i corresponde al final de la ventana i..i+W-1
        ep_to_max = i + smooth_window
        max_ret = float(np.max(r_smooth))
        return ep_to_max, max_ret

    i = int(np.argmax(r))
    return i + 1, float(r[i])



if __name__ == "__main__":
    domain = "PDDLEnv<Domain>-v0"

    # Asegura que el problem_idx existe (evita el crash del idx=1)
    env_check = pddlgym.make(domain)
    n_probs = len(getattr(env_check, "problems", []))
    if n_probs == 0:
        raise RuntimeError(f"{domain} no tiene problemas cargados.")
    problem_idx = 0  # <- usa 0 o el que exista: 0..n_probs-1

    # GRID como el de la tabla (ajusta a tu gusto)
    alphas = [0.1, 0.2, 0.5]
    gammas = [0.9, 0.95, 0.99]
    eps_decays = [0.99, 0.995, 0.999]

    # Repeticiones (en tu tabla parecen varias filas por misma combinación)
    seeds = [0, 1, 2]   # 3 repeticiones

    total_episodes = 3000
    max_steps = 2000
    epsilon_start = 1.0
    epsilon_min = 0.01

    smooth_window = 1  # pon 1 para "max return" puro; o 50 si quieres media móvil

    rows = []

    for alpha, gamma, eps_decay in itertools.product(alphas, gammas, eps_decays):
        for seed in seeds:
            print(f"Grid: alpha={alpha}, gamma={gamma}, eps_decay={eps_decay}, seed={seed}")

            env = make_env(domain=domain, problem_idx=problem_idx)

            res = run_q_learning(
                env=env,
                total_episodes=total_episodes,
                learning_rate=alpha,
                gamma=gamma,
                epsilon_start=epsilon_start,
                epsilon_min=epsilon_min,
                epsilon_decay=eps_decay,
                max_steps=max_steps,
                seed=seed,
                # opcional: puedes fijar early stop o no
                early_stop_on_convergence=False,  # para que siempre llegue a total_episodes
            )

            ep_to_max, max_ret = episodes_to_max_and_max_return(
                res["episode_rewards"],
                smooth_window=smooth_window
            )

            rows.append({
                "alpha": alpha,
                "gamma": gamma,
                "epsilon_decay": eps_decay,
                "seed": seed,
                "Episodes to max return": ep_to_max,
                "Max return": max_ret,
                "Episodes run": len(res["episode_rewards"]),
                "n_states": len(res["vistos"]),
            })

    df_grid = pd.DataFrame(rows)

    # (Opcional) ordenar como en la tabla
    df_grid = df_grid.sort_values(["alpha", "gamma", "epsilon_decay", "seed"]).reset_index(drop=True)

    print("\n===== GRID SEARCH RESULTS =====")
    print(df_grid[["alpha", "gamma", "epsilon_decay", "Episodes to max return", "Max return"]])

    df_grid.to_csv("gridsearch_qlearning.csv", index=False)
    print("\n[OK] CSV guardado: gridsearch_qlearning.csv")