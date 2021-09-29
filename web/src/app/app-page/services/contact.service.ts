import { Injectable } from "@angular/core";
import { Contact } from "../../domain/contact";
import { CommunicationService, EventType } from "../../services/communication.service";

@Injectable()
export class ContactService {

    contactList: Contact[] = []

    constructor(private com: CommunicationService) {
        com.contacts$.subscribe(event => {
            if (event.type == EventType.PUT) {
                const contact = event.contact

                if (contact != null) {
                    const index = this.contactList.findIndex(c => c.phoneNumber == contact.phoneNumber)
                    if (index == -1) {
                        this.contactList.push(contact)
                    } else {
                        this.contactList[index] = contact
                    }
                }
            } else if (event.type == EventType.DELETE) {
                this.contactList = this.contactList.filter(c => c.phoneNumber != event.contactPhoneNumber)
            }
        })
    }
}
