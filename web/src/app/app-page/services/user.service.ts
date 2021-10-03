import { Injectable } from "@angular/core";
import { CommunicationService } from "../../services/communication.service";
import { ReplaySubject } from "rxjs";

@Injectable()
export class UserService {

    displayName$ = new ReplaySubject<string>()
    profileImage$ = new ReplaySubject<string>()

    constructor(private com: CommunicationService) {
        com.userDisplayName$.subscribe(next => this.displayName$.next(next))
        com.userProfileImage$.subscribe(next => this.profileImage$.next(next))
    }

}
