package za.ac.up.cs.atbash.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "users")
public class User {
    @Id
    public String id;

    public String phoneNumber;
    public String password;
    public String deviceToken;

    public User() {
    }

    public User(String phoneNumber, String password, String deviceToken) {
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.deviceToken = deviceToken;
    }
}
