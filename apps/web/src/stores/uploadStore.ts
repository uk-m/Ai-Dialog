import { create } from "zustand";

export type UploadItem = {
  id: string;
  file: File;
  status: "pending" | "uploading" | "success" | "error";
  progress: number;
  entryId?: number;
  error?: string;
};

type UploadState = {
  queue: UploadItem[];
  addFiles: (files: FileList | File[]) => void;
  updateItem: (id: string, patch: Partial<UploadItem>) => void;
  clearFinished: () => void;
};

const toArray = (files: FileList | File[]) =>
  Array.isArray(files) ? files : Array.from(files);

export const useUploadStore = create<UploadState>((set) => ({
  queue: [],
  addFiles: (files) =>
    set((state) => ({
      queue: [
        ...state.queue,
        ...toArray(files).map((file) => ({
          id: `${file.name}-${crypto.randomUUID()}`,
          file,
          status: "pending" as const,
          progress: 0,
        })),
      ],
    })),
  updateItem: (id, patch) =>
    set((state) => ({
      queue: state.queue.map((item) =>
        item.id === id ? { ...item, ...patch } : item,
      ),
    })),
  clearFinished: () =>
    set((state) => ({
      queue: state.queue.filter((item) => item.status === "uploading" || item.status === "pending"),
    })),
}));
