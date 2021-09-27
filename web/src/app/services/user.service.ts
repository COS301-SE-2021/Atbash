import { Injectable } from "@angular/core";
import { CommunicationService } from "./communication.service";

@Injectable({
    providedIn: "root"
})
export class UserService {

    profileImage: string | null = null
    displayName: string = ""

    constructor(private com: CommunicationService) {
        com.fetchUserDisplayName().then(displayName => this.displayName = displayName)
        com.fetchUserProfileImage().then(profileImage => this.profileImage = profileImage)
    }

}
