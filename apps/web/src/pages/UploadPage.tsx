import { ChangeEvent, useState } from "react";
import { uploadPhoto } from "../api/diary";
import { useUploadStore } from "../stores/uploadStore";
import { Button } from "../components/ui/button";
import { Label } from "../components/ui/label";
import { Input } from "../components/ui/input";
import { UploadQueue } from "../components/UploadQueue";

export const UploadPage = () => {
  const { addFiles, queue, updateItem } = useUploadStore();
  const [journalDate, setJournalDate] = useState(() => new Date().toISOString().slice(0, 10));

  const handleSelect = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.files) {
      addFiles(event.target.files);
    }
  };

  const handleUpload = async () => {
    for (const item of queue) {
      if (item.status === "success") continue;
      updateItem(item.id, { status: "uploading", progress: 20 });
      try {
        await uploadPhoto(item.file, { journal_date: journalDate });
        updateItem(item.id, { status: "success", progress: 100 });
      } catch (error) {
        updateItem(item.id, {
          status: "error",
          error: error instanceof Error ? error.message : "アップロードに失敗しました",
        });
      }
    }
  };

  return (
    <section className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">画像アップロード</h1>
        <p className="text-sm text-muted-foreground">
          画像を登録すると AI が日記の下書きを自動生成します。
        </p>
      </div>

      <div className="rounded-lg border bg-card p-6 shadow-sm">
        <div className="grid gap-4 md:grid-cols-2">
          <div className="space-y-2">
            <Label htmlFor="date">日付</Label>
            <Input
              id="date"
              type="date"
              value={journalDate}
              onChange={(event) => setJournalDate(event.target.value)}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="file">画像ファイル</Label>
            <Input id="file" type="file" accept="image/*" multiple onChange={handleSelect} />
          </div>
        </div>
        <Button className="mt-4" onClick={handleUpload} disabled={!queue.length}>
          アップロード開始
        </Button>
      </div>

      <UploadQueue />
    </section>
  );
};
