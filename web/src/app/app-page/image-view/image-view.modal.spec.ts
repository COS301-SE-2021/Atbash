import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ImageViewModal } from './image-view.modal';

describe('ImageViewModal', () => {
  let component: ImageViewModal;
  let fixture: ComponentFixture<ImageViewModal>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ImageViewModal ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ImageViewModal);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
