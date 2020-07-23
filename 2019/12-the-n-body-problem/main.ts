import readInputFile from "../read-input-file.ts";

const input = readInputFile();

type Axis = [number, number, number];

class Moon {
  pos: Axis;

  vel: Axis = [0, 0, 0];

  initialPos: Axis;

  get pot(): number {
    return this.pos.reduce((acc, p) => acc + Math.abs(p), 0);
  }

  get kin(): number {
    return this.vel.reduce((acc, v) => acc + Math.abs(v), 0);
  }

  constructor(pos: string) {
    this.pos = pos.replace(/[^-\d,]/g, "").split(",").map((i) => ~~i) as Axis;
    this.initialPos = [...this.pos];
  }

  applyGravity(moons: Moon[]): void {
    moons.forEach(({ pos }) =>
      pos.forEach((p, i) =>
        p != this.pos[i] && (this.vel[i] += this.pos[i] < p ? 1 : -1)
      )
    );
  }

  applyVelocity(): void {
    this.vel.forEach((v, i) => this.pos[i] += v);
  }
}

const gcd = (x: number, y: number): number => !y ? x : gcd(y, x % y);
const lcm = (items: number[]) =>
  items.reduce((acc, i) => acc * i / gcd(acc, i), 1);

const run = (moons: Moon[]): void => {
  moons.forEach((m, i) =>
    m.applyGravity([...moons.slice(0, i), ...moons.slice(i + 1)])
  );
  moons.forEach((m) => m.applyVelocity());
};

const partOne = (): number => {
  const moons = input.split("\n").map((l) => new Moon(l));
  for (let i = 0; i < 1000; i++) run(moons);

  return moons.reduce((acc, m) => acc + m.pot * m.kin, 0);
};

const partTwo = (): number => {
  const lines = input.split("\n");

  return lcm(Array.from(Array(3), (_, i) => {
    let steps = 0;
    const moons = lines.map((l) => new Moon(l));

    while (true) {
      run(moons);
      steps += 1;

      if (moons.every((m) => m.pos[i] == m.initialPos[i] && m.vel[i] == 0)) {
        break;
      }
    }

    return steps;
  }));
};

console.log(partOne());
console.log(partTwo());
