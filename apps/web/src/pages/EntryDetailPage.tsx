import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { fetchDiaryEntry, updateDiaryEntry } from "../api/diary";
import type { DiaryEntry } from "../api/types";
import { Input } from "../components/ui/input";
import { Textarea } from "../components/ui/textarea";
import { Button } from "../components/ui/button";

export const EntryDetailPage = () => {
  const { id } = useParams<{ id: string }>();
  const [entry, setEntry] = useState<DiaryEntry | null>(null);
  const [status, setStatus] = useState<"idle" | "saving">("idle");

  useEffect(() => {
    const load = async () => {
      if (!id) return;
      const response = await fetchDiaryEntry(Number(id));
      setEntry(response);
    };
    load();
  }, [id]);

  const handleSave = async () => {
    if (!entry) return;
    setStatus("saving");
    await updateDiaryEntry(entry.id, {
      title: entry.title,
      body: entry.body,
      tags: entry.tags,
    });
    setStatus("idle");
  };

  if (!entry) {
    return <p className="text-sm text-muted-foreground">読込中...</p>;
  }

  return (
    <section className="space-y-4">
      <div>
        <h1 className="text-2xl font-semibold">{entry.title}</h1>
        <p className="text-sm text-muted-foreground">{entry.journal_date}</p>
      </div>
      <Input
        value={entry.title}
        onChange={(event) => setEntry({ ...entry, title: event.target.value })}
      />
      <Textarea
        value={entry.body}
        onChange={(event) => setEntry({ ...entry, body: event.target.value })}
      />
      <Button onClick={handleSave} disabled={status === "saving"}>
        保存
      </Button>
    </section>
  );
};
