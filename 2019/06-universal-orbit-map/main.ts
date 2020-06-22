import readInputFile from "../read-input-file.ts";

const input = readInputFile();

interface Orbits {
  [propName: string]: string[];
}

class Planet {
  name: string;

  satellites: Planet[] = [];

  orbits: number;

  parent?: Planet;

  constructor(name: string, orbits = 0, parent?: Planet) {
    this.name = name;
    this.orbits = orbits;
    this.parent = parent;
  }
}

const orbits = input.split("\n").reduce(
  (acc: Orbits, orbit) => {
    const [p, s] = orbit.split(")");
    acc[p] = acc[p] ? [...acc[p], s] : [s];

    return acc;
  },
  {},
);

const drawOrbit = (orbits: Orbits, planet: Planet): Planet => {
  const satellites = orbits[planet.name];
  if (satellites) {
    planet.satellites = satellites.map((name) =>
      drawOrbit(orbits, new Planet(name, planet.orbits + 1, planet))
    );
  }

  return planet;
};

const COM = drawOrbit(orbits, new Planet("COM"));

const findPlanet = (planet: Planet, name: string): Planet | void => {
  for (let i = 0; i < planet.satellites.length; i++) {
    let s = planet.satellites[i];

    if (s.name == name) {
      return s;
    }

    const result = findPlanet(s, name);
    if (result) {
      return result;
    }
  }
};

const findCommonPlanet = (planet: Planet, name: string): Planet => {
  if (findPlanet(planet, name)) {
    return planet;
  }

  return findCommonPlanet(planet.parent as Planet, name);
};

const partOne = (planet: Planet): number => {
  return planet.satellites.reduce(
    (acc: number, s) => acc + partOne(s),
    planet.orbits,
  );
};

const partTwo = (planet: Planet): number => {
  const [YOU, SAN] = ["YOU", "SAN"].map((n) => findPlanet(planet, n) as Planet);
  const common = findCommonPlanet(YOU, SAN.name);

  return YOU.orbits + SAN.orbits - common.orbits * 2 - 2;
};

console.log(partOne(COM));
console.log(partTwo(COM));
