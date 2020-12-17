import readInputFile from "../read-input-file.ts";

const input = readInputFile();

// https://work.njae.me.uk/2019/12/20/advent-of-code-2019-day-16/
// Going faster

// The trick is to exploit the structure of the extended pattern,
// especially when applied to the last few digits of the message.

// When we're calculating the last digit in the new message,
// the pattern for that new digit will be many zeros and one one: it will look like [0, 0 … 0, 1].
// That means the last digit of the message remains the same.

// The pattern for the second-from-last digit is [0, 0 … 0, 1, 1],
// so the second-from-last digit in the new message is the sum of the last two digits in the old message (mod 10).
// The third-from-last digit uses the pattern s [0, 0 … 0, 1, 1, 1],
// so it's the sum of the last three digits in the old message (mod 10).
// This structure repeats for all the digits in the latter half of the message.

const fft = (signals: number[], trick = false): number[] => {
  if (trick) {
    return signals.reduce((acc, s, i) => {
      if (i == 0) {
        return [s];
      }

      acc.push((s + acc[i - 1]) % 10);
      return acc;
    }, [] as number[]);
  }

  return signals.map((_, i) =>
    Math.abs(signals.reduce((acc, s, k) => {
      const pattern = [0, 1, 0, -1][Math.floor((k + 1) / (i + 1)) % 4];
      return acc + s * pattern;
    }, 0)) % 10
  );
};

const partOne = (): string => {
  let signals = input.split("").map((i) => ~~i);

  for (let i = 0; i < 100; i++) {
    signals = fft(signals);
  }

  return signals.slice(0, 8).join("");
};

const partTwo = (): string => {
  let signals = input.split("").map((i) => ~~i);
  const offset = ~~signals.slice(0, 7).join("");
  signals = Array.from(
    Array(Math.ceil((signals.length * 10000 - offset) / signals.length)),
    () => signals,
  ).flat().slice(offset % signals.length).reverse();

  for (let i = 0; i < 100; i++) {
    signals = fft(signals, true);
  }

  return signals.reverse().slice(0, 8).join("");
};

console.log(partOne());
console.log(partTwo());
