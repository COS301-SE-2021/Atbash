import { Component, Input, OnInit } from "@angular/core";
import { Contact } from "../../../domain/contact";

@Component({
    selector: "app-contact-item",
    templateUrl: "./contact-item.component.html",
    styleUrls: ["./contact-item.component.scss"]
})
export class ContactItemComponent implements OnInit {

    // LOCAL STATE
    @Input() contact: Contact | null = null

    constructor() {
    }

    ngOnInit(): void {
    }

    get profileImage() {
        let profileImage = this.contact?.profileImage
        if (profileImage == null || profileImage.trim() == "") {
            profileImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
        }
        return profileImage
    }

    get displayName() {
        return this.contact?.displayName ?? this.contact?.phoneNumber ?? ""
    }

}
