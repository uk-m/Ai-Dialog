import { useCallback, useEffect, useState } from "react";
import { fetchWeeklyDigests, triggerWeeklyDigest } from "../api/diary";
import type { WeeklyDigest } from "../api/types";

export const useWeeklyDigests = () => {
  const [digests, setDigests] = useState<WeeklyDigest[]>([]);
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const entries = await fetchWeeklyDigests();
      setDigests(entries);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  const requestDigest = useCallback(
    async (weekOf?: string) => {
      await triggerWeeklyDigest(weekOf);
    },
    [],
  );

  return { digests, loading, reload: load, requestDigest };
};
