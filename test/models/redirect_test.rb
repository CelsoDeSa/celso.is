require "test_helper"

class RedirectTest < ActiveSupport::TestCase
  setup do
    @contact = redirects(:contact_redirect)
    @external = redirects(:external_redirect)
    @inactive = redirects(:inactive_redirect)
  end

  test "redirect requires a source" do
    redirect = Redirect.new(destination: "/somewhere")
    assert_not redirect.valid?
    assert_includes redirect.errors[:source], "can't be blank"
  end

  test "redirect requires a destination" do
    redirect = Redirect.new(source: "somewhere")
    assert_not redirect.valid?
    assert_includes redirect.errors[:destination], "can't be blank"
  end

  test "redirect source must be unique" do
    redirect = Redirect.new(source: @contact.source, destination: "/other")
    assert_not redirect.valid?
    assert_includes redirect.errors[:source], "has already been taken"
  end

  test "active scope returns only active redirects" do
    actives = Redirect.active
    assert_includes actives.to_a, @contact
    assert_includes actives.to_a, @external
    assert_not_includes actives.to_a, @inactive
  end

  test "can create valid redirect" do
    redirect = Redirect.new(
      source: "new-redirect",
      destination: "/destination",
      active: true
    )
    assert redirect.valid?
    assert redirect.save
  end

  test "source can be any string format" do
    redirect = Redirect.new(
      source: "my-custom-path-123",
      destination: "/destination",
      active: true
    )
    assert redirect.valid?
  end

  test "destination can be external URL" do
    redirect = Redirect.new(
      source: "external",
      destination: "https://example.com/path",
      active: true
    )
    assert redirect.valid?
  end

  test "destination can be internal path" do
    redirect = Redirect.new(
      source: "internal",
      destination: "/internal/path",
      active: true
    )
    assert redirect.valid?
  end

  test "find by source is case sensitive" do
    found = Redirect.find_by(source: "contact")
    assert_equal @contact, found
    
    not_found = Redirect.find_by(source: "CONTACT")
    assert_nil not_found
  end
end
