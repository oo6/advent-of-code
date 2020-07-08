import readInputFile from "../read-input-file.ts";

const input = readInputFile();
const layers = input.match(/.{1,150}/g) as string[];

const digitCount = (layer: string, digit: string): number => {
  return layer.match(new RegExp(digit, "g"))?.length as number;
};

const topVisiblePixel = (index: number): string => {
  const layer = layers.find((l) => l[index] != "2");
  return layer ? layer[index] : "2";
};

const partOne = (): number => {
  const results = layers.reduce((acc, l) => {
    const c = digitCount(l, "0");
    c && (acc[c] = l);

    return acc;
  }, {} as Record<string, string>) as Record<string, string>;
  const min = results[Math.min(...Object.keys(results).map((i) => ~~i))];

  return digitCount(min, "1") * digitCount(min, "2");
};

const partTwo = (): string => {
  return Array.from(Array(150), (_, i) => topVisiblePixel(i))
    .join("")
    .match(/.{1,25}/g)
    ?.map((i) => i.replace(/0/g, " "))
    .join("\n") as string;
};

console.log(partOne());
console.log(partTwo());
