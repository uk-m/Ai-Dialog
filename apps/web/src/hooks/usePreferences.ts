import { useAtom } from "jotai";
import { useCallback, useEffect, useState } from "react";
import { fetchPreferences, updatePreferences } from "../api/diary";
import {
  defaultPreferences,
  preferencesAtom,
  type Preferences,
} from "../stores/preferencesAtom";

export const usePreferences = () => {
  const [preferences, setPreferences] = useAtom(preferencesAtom);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      try {
        const data = await fetchPreferences();
        setPreferences({ ...defaultPreferences, ...data } as Preferences);
      } catch (error) {
        console.error("Failed to load preferences", error);
      } finally {
        setLoading(false);
      }
    };

    load();
  }, [setPreferences]);

  const save = useCallback(
    async (patch: Partial<Preferences>) => {
      const next = { ...preferences, ...patch };
      setPreferences(next);
      await updatePreferences(next);
    },
    [preferences, setPreferences],
  );

  return { preferences, loading, save };
};
