import { ISBN } from './ISBN.js';

export interface BookProps {
  id: string;
  isbn: ISBN;
  title: string;
  author: string;
  publisher: string;
  categoryId?: string | null;
  publicationYear?: number | null;
  metadata?: Record<string, any>;
  createdAt?: Date;
  updatedAt?: Date;
}

export class Book {
  private readonly props: BookProps;

  constructor(props: BookProps) {
    if (!props.id) {
      throw new Error('Book ID is required');
    }
    if (!props.title || props.title.trim().length === 0) {
      throw new Error('Book title cannot be empty');
    }
    if (!props.author || props.author.trim().length === 0) {
      throw new Error('Book author cannot be empty');
    }
    if (!props.publisher || props.publisher.trim().length === 0) {
      throw new Error('Book publisher cannot be empty');
    }

    this.props = {
      ...props,
      metadata: props.metadata || {},
      createdAt: props.createdAt || new Date(),
      updatedAt: props.updatedAt || new Date(),
    };
  }

  public getId(): string {
    return this.props.id;
  }

  public getIsbn(): ISBN {
    return this.props.isbn;
  }

  public getTitle(): string {
    return this.props.title;
  }

  public getAuthor(): string {
    return this.props.author;
  }

  public getPublisher(): string {
    return this.props.publisher;
  }

  public getCategoryId(): string | null | undefined {
    return this.props.categoryId;
  }

  public getPublicationYear(): number | null | undefined {
    return this.props.publicationYear;
  }

  public getMetadata(): Record<string, any> {
    return this.props.metadata || {};
  }

  public getCreatedAt(): Date {
    return this.props.createdAt!;
  }

  public getUpdatedAt(): Date {
    return this.props.updatedAt!;
  }

  public toJSON() {
    return {
      id: this.getId(),
      isbn: this.getIsbn().getValue(),
      isbn_formatted: this.getIsbn().getFormatted(),
      title: this.getTitle(),
      author: this.getAuthor(),
      publisher: this.getPublisher(),
      category_id: this.getCategoryId() || null,
      publication_year: this.getPublicationYear() || null,
      metadata: this.getMetadata(),
      created_at: this.getCreatedAt().toISOString(),
      updated_at: this.getUpdatedAt().toISOString(),
    };
  }
}
