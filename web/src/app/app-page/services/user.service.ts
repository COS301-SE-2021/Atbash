import { Injectable } from "@angular/core";
import { CommunicationService } from "../../services/communication.service";

@Injectable()
export class UserService {

    profileImage: string | null = null
    displayName: string = ""

    constructor(private com: CommunicationService) {
        com.userDisplayName$.subscribe(next => this.displayName = next)
        com.userProfileImage$.subscribe(next => this.profileImage = next)
    }

}
