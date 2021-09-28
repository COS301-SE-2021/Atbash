import { Injectable } from "@angular/core";
import { CommunicationService } from "../../services/communication.service";

@Injectable()
export class UserService {

    profileImage: string | null = null
    displayName: string = ""

    constructor(private com: CommunicationService) {
        com.fetchUserDisplayName().then(displayName => this.displayName = displayName)
        com.fetchUserProfileImage().then(profileImage => this.profileImage = profileImage)
    }

}