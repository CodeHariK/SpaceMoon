const alphanumericRegex: RegExp = /^[a-zA-Z0-9]+$/;

export function isAlphanumeric(input: string) {
    return alphanumericRegex.test(input);
}
