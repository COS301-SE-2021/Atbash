import { Contact } from "./contact";
import { Message } from "./message";

export class Chat {
    public readonly id: string
    public readonly contactPhoneNumber: string
    public contact: Contact | null = null
    public readonly chatType: ChatType
    public mostRecentMessage: Message | null = null

    constructor(id: string, contactPhoneNumber: string, contact: Contact | null, chatType: ChatType, mostRecentMessage: Message | null) {
        this.id = id;
        this.contactPhoneNumber = contactPhoneNumber;
        this.contact = contact;
        this.chatType = chatType;
        this.mostRecentMessage = mostRecentMessage;
    }
}

enum ChatType {
    general,
    private
}
