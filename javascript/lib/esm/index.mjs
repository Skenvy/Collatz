// This is an example src from
// https://github.com/snyk-snippets/modern-npm-package/blob/main/src/index.ts
// MIT: https://github.com/snyk-snippets/modern-npm-package/blob/main/LICENSE
export function helloWorld() {
    const message = 'Hello World from my example modern npm package!';
    return message;
}
export function goodBye() {
    const message = 'Goodbye from my example modern npm package!';
    return message;
}
export default {
    helloWorld,
    goodBye,
};
