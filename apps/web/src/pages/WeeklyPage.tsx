import { useWeeklyDigests } from "../hooks/useWeeklyDigests";
import { WeeklyDigestCard } from "../components/WeeklyDigestCard";
import { Button } from "../components/ui/button";

export const WeeklyPage = () => {
  const { digests, loading, reload, requestDigest } = useWeeklyDigests();

  const handleGenerate = async () => {
    await requestDigest();
    setTimeout(reload, 2000);
  };

  return (
    <section className="space-y-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold">週次まとめ</h1>
          <p className="text-sm text-muted-foreground">AI が週一でまとめを作成します。</p>
        </div>
        <Button onClick={handleGenerate} disabled={loading}>
          即時生成
        </Button>
      </header>

      <div className="space-y-4">
        {digests.map((digest) => (
          <WeeklyDigestCard key={digest.id} digest={digest} />
        ))}
      </div>
    </section>
  );
};
