export interface IMessage {
    id: string,
    chatId: string,
    isIncoming: boolean,
    otherPartyPhoneNumber: string,
    contents: string,
    timestamp: number,
    isMedia: boolean,
    forwarded: boolean,
    readReceipt: number,
    repliedMessageId?: string,
    deleted: boolean,
    liked: boolean,
    edited: boolean,
}

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
    public repliedMessageId?: string
    public deleted: boolean = false
    public liked: boolean = false
    public edited: boolean = false

    constructor(id: string, chatId: string, isIncoming: boolean, otherPartyPhoneNumber: string, contents: string, timestamp: Date, isMedia: boolean, forwarded: boolean, readReceipt: ReadReceipt, repliedMessageId: string | undefined, deleted: boolean, liked: boolean, edited: boolean) {
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

    static fromIMessage(iMessage: IMessage) {
        return new Message(
            iMessage.id,
            iMessage.chatId,
            iMessage.isIncoming,
            iMessage.otherPartyPhoneNumber,
            iMessage.contents,
            new Date(iMessage.timestamp),
            iMessage.isMedia,
            iMessage.forwarded,
            this.getReadReceipt(iMessage.readReceipt),
            iMessage.repliedMessageId,
            iMessage.deleted,
            iMessage.liked,
            iMessage.edited,
        )
    }

    static getReadReceipt(index: number) {
        if (index == 0)
            return ReadReceipt.undelivered
        if (index == 1)
            return ReadReceipt.delivered
        if (index == 2)
            return ReadReceipt.seen

        return ReadReceipt.undelivered
    }
}

export enum ReadReceipt {
    undelivered,
    delivered,
    seen
}
