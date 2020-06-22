export default function readInputFile(): string {
  return Deno.readTextFileSync("input.txt");
}
