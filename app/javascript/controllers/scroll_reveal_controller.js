import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-reveal"
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.reveal(entry.target)
          }
        })
      },
      {
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px" // Trigger slightly before the element fully enters viewport
      }
    )

    this.itemTargets.forEach((el) => {
      // Add initial hidden state classes right away to prevent flash
      el.classList.add("opacity-0", "translate-y-8", "transition-all", "duration-1000", "ease-out")

      this.observer.observe(el)
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  reveal(element) {
    // Small timeout to allow initial classes to take effect
    setTimeout(() => {
      element.classList.remove("opacity-0", "translate-y-8")
      element.classList.add("opacity-100", "translate-y-0")
      // Stop observing once revealed
      this.observer.unobserve(element)
    }, 50)
  }
}
