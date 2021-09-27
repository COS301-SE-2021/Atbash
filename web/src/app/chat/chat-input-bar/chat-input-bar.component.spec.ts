import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChatInputBarComponent } from './chat-input-bar.component';

describe('ChatInputBarComponent', () => {
  let component: ChatInputBarComponent;
  let fixture: ComponentFixture<ChatInputBarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ChatInputBarComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ChatInputBarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
