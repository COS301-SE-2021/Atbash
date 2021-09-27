import { Injectable } from "@angular/core";
import { Contact } from "../domain/contact";
import { CommunicationService } from "./communication.service";

@Injectable({
    providedIn: "root"
})
export class ContactService {

    contactList: Contact[] = []

    constructor(private com: CommunicationService) {
        com.fetchContactList().then(contacts => this.contactList = contacts)
    }
}
