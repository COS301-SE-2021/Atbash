export class Contact {
    public readonly phoneNumber: string
    public readonly displayName: string
    public readonly status: string
    public readonly profileImage: string
    public birthday: Date | null = null

    constructor(phoneNumber: string, displayName: string, status: string, profileImage: string, birthday: Date | null) {
        this.phoneNumber = phoneNumber;
        this.displayName = displayName;
        this.status = status;
        this.profileImage = profileImage;
        this.birthday = birthday;
    }
}
