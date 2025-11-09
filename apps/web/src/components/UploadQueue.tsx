import { useUploadStore } from "../stores/uploadStore";
import { Button } from "./ui/button";
import { ProgressBar } from "./progress-bar";

export const UploadQueue = () => {
  const { queue, clearFinished } = useUploadStore();

  if (!queue.length) return null;

  return (
    <div className="rounded-lg border bg-card p-4">
      <div className="mb-3 flex items-center justify-between text-sm font-medium">
        <span>アップロードキュー</span>
        <Button variant="ghost" size="sm" onClick={clearFinished}>
          完了をクリア
        </Button>
      </div>
      <div className="space-y-3">
        {queue.map((item) => (
          <div key={item.id} className="rounded border p-3">
            <div className="flex justify-between text-sm font-medium">
              <span>{item.file.name}</span>
              <span
                className={
                  item.status === "success"
                    ? "text-green-600"
                    : item.status === "error"
                      ? "text-red-600"
                      : "text-muted-foreground"
                }
              >
                {item.status}
              </span>
            </div>
            <ProgressBar value={item.progress} />
            {item.error && <p className="text-xs text-red-500">{item.error}</p>}
          </div>
        ))}
      </div>
    </div>
  );
};
