import { apiClient } from "./client";
import type { ApiMeta, DiaryEntry, WeeklyDigest } from "./types";

export const fetchDiaryEntries = async (page = 1) => {
  const response = await apiClient.get<{ data: DiaryEntry[]; meta: ApiMeta }>(
    "/diary_entries",
    { params: { page } },
  );
  return response.data;
};

export const fetchDiaryEntry = async (id: number) => {
  const response = await apiClient.get<DiaryEntry>(`/diary_entries/${id}`);
  return response.data;
};

export const createDiaryEntry = async (payload: Partial<DiaryEntry>) => {
  const response = await apiClient.post<DiaryEntry>("/diary_entries", {
    diary_entry: {
      title: payload.title,
      body: payload.body,
      journal_date: payload.journal_date,
      status: payload.status,
      tag_names: payload.tags,
    },
  });
  return response.data;
};

export const uploadPhoto = async (file: File, extras?: Record<string, unknown>) => {
  const formData = new FormData();
  formData.append("photo", file);
  if (extras?.title) formData.append("title", String(extras.title));
  if (extras?.journal_date) formData.append("journal_date", String(extras.journal_date));
  const response = await apiClient.post<DiaryEntry>("/uploads", formData, {
    headers: { "Content-Type": "multipart/form-data" },
  });
  return response.data;
};

export const updateDiaryEntry = async (id: number, payload: Partial<DiaryEntry>) => {
  const response = await apiClient.put<DiaryEntry>(`/diary_entries/${id}`, {
    diary_entry: {
      title: payload.title,
      body: payload.body,
      journal_date: payload.journal_date,
      status: payload.status,
      tag_names: payload.tags,
    },
  });
  return response.data;
};

export const publishDiaryEntry = async (id: number) => {
  const response = await apiClient.post<DiaryEntry>(`/diary_entries/${id}/publish`);
  return response.data;
};

export const regenerateDiaryEntry = async (id: number) =>
  apiClient.post(`/diary_entries/${id}/regenerate`);

export const fetchCalendarHeatmap = async () => {
  const response = await apiClient.get<Array<{ date: string; count: number }>>(
    "/diary_entries/calendar",
  );
  return response.data;
};

export const fetchTimeline = async () => {
  const response = await apiClient.get<DiaryEntry[]>("/diary_entries/timeline");
  return response.data;
};

export const fetchWeeklyDigests = async () => {
  const response = await apiClient.get<{ data: WeeklyDigest[] }>("/weekly_digests");
  return response.data.data;
};

export const triggerWeeklyDigest = async (weekOf?: string) => {
  await apiClient.post("/weekly_digests/generate", { week_of: weekOf });
};

export const fetchPreferences = async () => {
  const response = await apiClient.get<Record<string, string>>("/preferences");
  return response.data;
};

export const updatePreferences = async (prefs: Record<string, string>) => {
  const response = await apiClient.put<Record<string, string>>("/preferences", {
    preferences: prefs,
  });
  return response.data;
};
