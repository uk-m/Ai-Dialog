import axios from "axios";
import { API_BASE_URL } from "../config";

const TOKEN_STORAGE_KEY = "aidia.tokens";

type AuthHeaders = {
  "access-token": string;
  client: string;
  expiry: string;
  uid: string;
  "token-type": string;
};

export const loadAuthHeaders = (): Partial<AuthHeaders> => {
  try {
    const raw = localStorage.getItem(TOKEN_STORAGE_KEY);
    return raw ? (JSON.parse(raw) as AuthHeaders) : {};
  } catch (error) {
    console.warn("Failed to parse auth headers", error);
    return {};
  }
};

export const persistAuthHeaders = (headers: Partial<AuthHeaders>) => {
  if (!headers["access-token"]) return;
  localStorage.setItem(TOKEN_STORAGE_KEY, JSON.stringify(headers));
};

export const apiClient = axios.create({
  baseURL: `${API_BASE_URL}/api/v1`,
  timeout: 15000,
});

apiClient.interceptors.request.use((config) => {
  const tokens = loadAuthHeaders();
  config.headers = {
    "Content-Type": "application/json",
    ...config.headers,
    ...tokens,
  };
  return config;
});

apiClient.interceptors.response.use((response) => {
  const authHeaders = {
    "access-token": response.headers["access-token"],
    client: response.headers.client,
    expiry: response.headers.expiry,
    uid: response.headers.uid,
    "token-type": response.headers["token-type"],
  };
  persistAuthHeaders(authHeaders);
  return response;
});
