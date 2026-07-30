export class ISBN {
  private readonly value: string;

  constructor(isbnStr: string) {
    const cleaned = isbnStr.replace(/[\s-]/g, '');
    if (!ISBN.isValidISBN13(cleaned)) {
      throw new Error(`Invalid ISBN-13 format or checksum: ${isbnStr}`);
    }
    this.value = cleaned;
  }

  public getValue(): string {
    return this.value;
  }

  public getFormatted(): string {
    // Format: 978-602-03-2412-1
    if (this.value.length === 13) {
      return `${this.value.substring(0, 3)}-${this.value.substring(3, 6)}-${this.value.substring(6, 8)}-${this.value.substring(8, 12)}-${this.value.substring(12)}`;
    }
    return this.value;
  }

  public static isValidISBN13(cleanIsbn: string): boolean {
    if (!/^\d{13}$/.test(cleanIsbn)) {
      return false;
    }

    let sum = 0;
    for (let i = 0; i < 12; i++) {
      const digit = parseInt(cleanIsbn[i], 10);
      sum += (i % 2 === 0) ? digit : digit * 3;
    }

    const checkDigit = (10 - (sum % 10)) % 10;
    const lastDigit = parseInt(cleanIsbn[12], 10);

    return checkDigit === lastDigit;
  }
}
