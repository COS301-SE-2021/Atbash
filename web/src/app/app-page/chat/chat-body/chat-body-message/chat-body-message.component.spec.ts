import { ComponentFixture, TestBed } from "@angular/core/testing";

import { ChatBodyMessageComponent } from "./chat-body-message.component";

describe("ChatBodyMessageComponent", () => {
    let component: ChatBodyMessageComponent;
    let fixture: ComponentFixture<ChatBodyMessageComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            declarations: [ChatBodyMessageComponent]
        })
            .compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(ChatBodyMessageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it("should create", () => {
        expect(component).toBeTruthy();
    });
});
