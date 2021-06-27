package za.ac.up.cs.atbash.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "messages")
public class Message {
    @Id
    public String id;

    public String phoneNumberFrom;
    public String phoneNumberTo;
    public String contents;
    public Date timestamp;

    public Message() {
    }

    public Message(String phoneNumberFrom, String phoneNumberTo, String contents, Date timestamp) {
        this.phoneNumberFrom = phoneNumberFrom;
        this.phoneNumberTo = phoneNumberTo;
        this.contents = contents;
        this.timestamp = timestamp;
    }
}