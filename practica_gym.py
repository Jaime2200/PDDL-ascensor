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
if __name__ == "__main__":
    problem_indices = [0, 1, 2, 3]  # problemas/tamaños distintos
    results_by_problem = []

    for idx in problem_indices:
        print(f"\n=== Ejecutando Q-learning para problema {idx} ===")
        env = make_env(domain="PDDLEnvAscensores-v0", problem_idx=idx)
        result = run_q_learning(env=env, total_episodes=3000)

        plan_cost = run_planner(idx)

        results_by_problem.append({
            "problem_idx": idx,
            "n_estados": len(result["vistos"]),
            "q_shape": result["q_shape"],
            "recompensa_media": np.mean(result["episode_rewards"]),
            "episodio_convergencia": result["converged_episode_exact"],
            "planificador_coste": plan_cost
        })

    df_comparativa = pd.DataFrame(results_by_problem)
    print("\n===== DATAFRAME COMPARATIVA =====")
    print(df_comparativa)

    # Export opcional
    df_comparativa.to_csv("comparativa_qlearning_planificador.csv", index=False)
    print("\n[OK] CSV guardado: comparativa_qlearning_planificador.csv")