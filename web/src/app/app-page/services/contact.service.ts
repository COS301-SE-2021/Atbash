import { Injectable } from "@angular/core";
import { Contact } from "../../domain/contact";
import { CommunicationService } from "../../services/communication.service";

@Injectable()
export class ContactService {

    contactList: Contact[] = []

    constructor(private com: CommunicationService) {
        com.contacts$.subscribe(next => this.contactList.push(next))
    }
}
