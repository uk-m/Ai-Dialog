import { CalendarDays, Clock, Tags, Wand } from "lucide-react";
import type { DiaryEntry } from "../api/types";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { formatDate } from "../lib/utils";
import { publishDiaryEntry, regenerateDiaryEntry } from "../api/diary";

type Props = {
  entry: DiaryEntry;
  onRefresh?: () => void;
};

export const DiaryCard = ({ entry, onRefresh }: Props) => {
  const handlePublish = async () => {
    await publishDiaryEntry(entry.id);
    onRefresh?.();
  };

  const handleRegenerate = async () => {
    await regenerateDiaryEntry(entry.id);
  };

  return (
    <Card key={entry.id}>
      <CardHeader className="space-y-2">
        <div className="flex items-center justify-between">
          <CardTitle>{entry.title}</CardTitle>
          <Badge variant={entry.status === "published" ? "default" : "outline"}>
            {entry.status === "published" ? "公開済み" : "下書き"}
          </Badge>
        </div>
        <CardDescription className="flex items-center gap-4 text-sm">
          <span className="flex items-center gap-1">
            <CalendarDays className="h-4 w-4" />
            {formatDate(entry.journal_date)}
          </span>
          {entry.mood && (
            <span className="flex items-center gap-1">
              <Clock className="h-4 w-4" />
              {entry.mood}
            </span>
          )}
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <p className="text-sm leading-relaxed text-muted-foreground">
          {entry.body || entry.ai_summary || "生成された本文を確認中です。"}
        </p>
        {entry.tags.length > 0 && (
          <div className="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
            <Tags className="h-4 w-4" />
            {entry.tags.map((tag) => (
              <Badge key={tag} variant="outline">
                {tag}
              </Badge>
            ))}
          </div>
        )}
        <div className="flex gap-2">
          {entry.status === "draft" && (
            <Button size="sm" onClick={handlePublish}>
              公開する
            </Button>
          )}
          <Button size="sm" variant="outline" onClick={handleRegenerate}>
            <Wand className="mr-1 h-4 w-4" />
            再生成
          </Button>
        </div>
      </CardContent>
    </Card>
  );
};
