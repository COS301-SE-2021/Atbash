export class Message {
    public readonly id: string
    public readonly chatId: string
    public readonly isIncoming: boolean
    public readonly otherPartyPhoneNumber: string
    public contents: string
    public readonly timestamp: Date
    public readonly isMedia: boolean = false
    public readonly forwarded: boolean = false
    public readReceipt: ReadReceipt = ReadReceipt.undelivered
    public repliedMessageId: string | null = null
    public deleted: boolean = false
    public liked: boolean = false
    public edited: boolean = false

    constructor(id: string, chatId: string, isIncoming: boolean, otherPartyPhoneNumber: string, contents: string, timestamp: Date, isMedia: boolean, forwarded: boolean, readReceipt: ReadReceipt, repliedMessageId: string | null, deleted: boolean, liked: boolean, edited: boolean) {
        this.id = id;
        this.chatId = chatId;
        this.isIncoming = isIncoming;
        this.otherPartyPhoneNumber = otherPartyPhoneNumber;
        this.contents = contents;
        this.timestamp = timestamp;
        this.isMedia = isMedia;
        this.forwarded = forwarded;
        this.readReceipt = readReceipt;
        this.repliedMessageId = repliedMessageId;
        this.deleted = deleted;
        this.liked = liked;
        this.edited = edited;
    }
}

enum ReadReceipt {
    undelivered,
    delivered,
    seen
}
