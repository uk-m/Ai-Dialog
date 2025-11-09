import { useCallback, useEffect, useState } from "react";
import { createDiaryEntry, fetchDiaryEntries, fetchTimeline } from "../api/diary";
import type { DiaryEntry } from "../api/types";

export const useDiaryEntries = () => {
  const [entries, setEntries] = useState<DiaryEntry[]>([]);
  const [timeline, setTimeline] = useState<DiaryEntry[]>([]);
  const [page, setPage] = useState(1);
  const [meta, setMeta] = useState({ total: 0, total_pages: 1 });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadEntries = useCallback(
    async (pageToLoad = 1) => {
      setLoading(true);
      try {
        const response = await fetchDiaryEntries(pageToLoad);
        setEntries(response.data);
        setMeta({
          total: response.meta.total,
          total_pages: response.meta.total_pages,
        });
        setPage(pageToLoad);
        setError(null);
      } catch (err) {
        setError(err instanceof Error ? err.message : "読み込みに失敗しました");
      } finally {
        setLoading(false);
      }
    },
    [],
  );

  const refreshTimeline = useCallback(async () => {
    try {
      const response = await fetchTimeline();
      setTimeline(response);
    } catch (err) {
      console.error(err);
    }
  }, []);

  const addEntry = useCallback(async (entry: Partial<DiaryEntry>) => {
    const created = await createDiaryEntry(entry);
    await Promise.all([loadEntries(page), refreshTimeline()]);
    return created;
  }, [loadEntries, page, refreshTimeline]);

  useEffect(() => {
    loadEntries(1);
    refreshTimeline();
  }, [loadEntries, refreshTimeline]);

  return {
    entries,
    timeline,
    page,
    meta,
    loading,
    error,
    loadEntries,
    addEntry,
  };
};
