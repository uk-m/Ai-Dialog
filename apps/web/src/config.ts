const env = import.meta.env;

export const API_BASE_URL = env.VITE_API_BASE_URL || "http://localhost:3000";
export const APP_HOST = env.VITE_APP_HOST || "http://localhost:5173";
export const APP_NAME = "AiDia";
