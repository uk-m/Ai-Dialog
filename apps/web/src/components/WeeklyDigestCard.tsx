import type { WeeklyDigest } from "../api/types";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { formatDate } from "../lib/utils";

export const WeeklyDigestCard = ({ digest }: { digest: WeeklyDigest }) => (
  <Card>
    <CardHeader>
      <CardTitle>{formatDate(digest.week_of)} 週のまとめ</CardTitle>
      <p className="text-sm text-muted-foreground">
        {digest.published_at ? `生成日: ${formatDate(digest.published_at)}` : "生成中"}
      </p>
    </CardHeader>
    <CardContent className="space-y-4">
      <p className="text-sm leading-relaxed">{digest.summary}</p>
      {Object.keys(digest.mood_trends).length > 0 && (
        <div className="space-y-2 text-sm">
          <p className="font-medium">ムード比率</p>
          <div className="flex flex-wrap gap-2">
            {Object.entries(digest.mood_trends).map(([mood, count]) => (
              <span key={mood} className="rounded-full bg-muted px-3 py-1 text-xs">
                {mood}: {count}
              </span>
            ))}
          </div>
        </div>
      )}
    </CardContent>
  </Card>
);
