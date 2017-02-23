require 'presenter_test_helper'

class ContactPresenterTest
  class PresentedContact < PresenterTestCase
    def format_name
      "contact"
    end

    test 'presents the title' do
      assert_equal schema_item['title'], presented_item.title
    end

    test 'only presents related item sections when section has items' do
      schema = schema_item('contact_with_email_and_no_other_contacts')
      presented = presented_item('contact_with_email_and_no_other_contacts')

      refute schema['links']['related']
      assert_empty presented.related_items[:sections].select { |section| section[:title] == 'Other contacts' }
    end

    test 'presents quick links in related items' do
      first_quick_link = schema_item['details']['quick_links'].first
      first_presented_quick_link = presented_item.related_items[:sections].first[:items].first

      assert_equal first_quick_link['title'], first_presented_quick_link[:title]
      assert_equal 'Elsewhere on GOV.UK', presented_item.related_items[:sections].first[:title]
    end

    test 'presents related contacts links in related items' do
      first_related_contact_link = schema_item['links']['related'].first
      first_presented_contact_link = presented_item.related_items[:sections].last[:items].first

      assert_equal first_related_contact_link['title'], first_presented_contact_link[:title]
      assert_equal 'Other contacts', presented_item.related_items[:sections].last[:title]
    end

    test 'presents online form links' do
      assert_equal schema_item['details']['contact_form_links'].first['link'], presented_item.online_form_links.first[:url]
    end

    test 'presents online form body' do
      assert_equal schema_item['details']['more_info_contact_form'], presented_item.online_form_body
    end

    test 'phone returns correctly' do
      phone_number = schema_item['details']['phone_numbers'][0]
      presented_phone_number = presented_item.phone[0]
      assert_equal phone_number["number"], presented_phone_number[:numbers][0][:number]
      assert_equal phone_number["textphone"].blank?, presented_phone_number[:numbers][0][:textphone].nil?
      assert_equal phone_number["title"], presented_phone_number[:title]
      assert_equal phone_number["description"].strip, presented_phone_number[:description]
      assert_equal phone_number["open_hours"].strip, presented_phone_number[:opening_times]
      assert_equal phone_number["best_time_to_call"].strip, presented_phone_number[:best_time_to_call]
    end

    test 'phone_body returns correctly' do
      assert_equal schema_item['details']['more_info_phone_number'], presented_item.phone_body
    end

    test 'post' do
      post_address = schema_item['details']['post_addresses'][0]
      presented_post_address = presented_item.post[0]
      assert_equal post_address['description'].strip, presented_post_address[:description]
      assert_equal post_address['title'].strip, presented_post_address[:v_card][0][:value]
      assert_equal 'fn', presented_post_address[:v_card][0][:v_card_class]
    end

    test 'post_body returns correctly' do
      assert_equal schema_item['details']['more_info_post_address'], presented_item.post_body
    end

    test 'email' do
      assert_equal schema_item['details']['email_addresses'][0]['email'].strip, presented_item.email[0][:email]
      assert_equal schema_item['details']['email_addresses'][0]['title'].strip, presented_item.email[0][:v_card][0][:value]
    end

    test 'email_body' do
      assert_equal schema_item['details']['more_info_email_address'], presented_item.email_body
    end
  end
end
