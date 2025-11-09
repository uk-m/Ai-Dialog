import { atom } from "jotai";

export type Preferences = {
  theme: "light" | "dark" | "system";
  language: string;
  week_start: "monday" | "sunday";
};

export const defaultPreferences: Preferences = {
  theme: "system",
  language: "ja",
  week_start: "monday",
};

export const preferencesAtom = atom<Preferences>(defaultPreferences);
