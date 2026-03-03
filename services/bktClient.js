import axios from "axios";

const baseUrl = process.env.BKT_BASE_URL || "http://localhost:8000";

export async function bktUpdate({ userId, skillId, correct, p_mastery = 0.2, p_learn, p_guess, p_slip }) {
    const { data } = await axios.post(`${baseUrl}/update`, {
        userId, skillId, correct, p_mastery, p_learn, p_guess, p_slip
    }, { timeout: 5000 });
    return data;
}

export async function bktNext({ userId, skillId, p_mastery = 0.2 }) {
    const { data } = await axios.post(`${baseUrl}/next`, { userId, skillId, p_mastery }, { timeout: 5000 });
    return data;
}
