import axios from "axios";

const baseUrl = process.env.BKT_BASE_URL || "http://localhost:8000";

export async function bktUpdate({ userId, skillId, correct, params = {} }) {
    const payload = {
        userId,
        skillId,
        correct,
        p_init: params.p_init,
        p_learn: params.p_learn,
        p_guess: params.p_guess,
        p_slip: params.p_slip,
    };
    const { data } = await axios.post(`${baseUrl}/update`, payload, { timeout: 5000 });
    return data;
}

export async function bktNext({ userId, skillId }) {
    const payload = { userId, skillId };
    const { data } = await axios.post(`${baseUrl}/next`, payload, { timeout: 5000 });
    return data;
}
