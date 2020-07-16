import readInputFile from "../read-input-file.ts";

const input = readInputFile();

interface Coordinate {
  x: number;
  y: number;
}

const detect = (self: Coordinate, asteroids: Coordinate[]): number => {
  const detected = asteroids.reduce((acc, a) => {
    acc.set(Math.atan2(a.y - self.y, a.x - self.x), true);
    return acc;
  }, new Map<number, true>());

  return detected.size;
};

const angle = (self: Coordinate, coord: Coordinate): number => {
  const angle = Math.atan2(self.y - coord.y, coord.x - self.x) * 180 / Math.PI;

  if (angle >= 0) {
    if (angle <= 90) {
      return 90 - angle;
    }
    return 360 - angle + 90;
  }

  return -angle + 90;
};

const distance = (self: Coordinate, coord: Coordinate): number => {
  return Math.sqrt(
    Math.pow(Math.abs(coord.x - self.x), 2) +
      Math.pow(Math.abs(coord.y - self.y), 2),
  );
};

const coords = input.split("\n").reduce((acc, l, y) => {
  l.split("").forEach((c, x) => {
    c == "#" && acc.push({ x, y });
  });

  return acc;
}, [] as Coordinate[]);

const stations = coords.reduce((acc, c, i) => {
  const count = detect(c, [...coords.slice(0, i), ...coords.slice(i + 1)]);
  acc[count] = c;

  return acc;
}, {} as Record<number, Coordinate>);

const partOne = (): number => {
  return Math.max(...Object.keys(stations).map((i) => ~~i));
};

const partTwo = (): number => {
  const max = Math.max(...Object.keys(stations).map((i) => ~~i));
  const location = stations[max];

  const angles = coords.filter((c) => c.x != location.x || c.y != location.y)
    .reduce(
      (acc, c) => {
        const a = angle(location, c);
        acc[a] = [...(acc[a] || []), c];

        return acc;
      },
      {} as Record<string, Coordinate[]>,
    );
  const keys = Object.keys(angles).sort((a, b) =>
    Number.parseFloat(a) - Number.parseFloat(b)
  );
  keys.forEach((k) =>
    angles[k].sort((a, b) => distance(location, a) - distance(location, b))
  );

  let count = 0, result: Coordinate | undefined;
  while (true) {
    for (let i = 0; i < keys.length; i++) {
      if (angles[keys[i]].length) {
        const c = angles[keys[i]].shift() as Coordinate;
        count++;

        if (count == 200) {
          result = c;
          break;
        }
      }
    }

    if (result) {
      break;
    }
  }

  return result.x * 100 + result.y;
};

console.log(partOne());
console.log(partTwo());
