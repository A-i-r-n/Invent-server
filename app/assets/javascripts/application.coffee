#= require jquery
#= require jquery_ujs
#= require mousetrap
#= require jquery_ui
#= require chosen.jquery
#= require nifty/dialog
#= require_tree .

$ ->
# Automatically focus all fields with the 'focus' class
  $('input.focus').focus()

  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()

  # When clicking the customer search button, toggle the form
  $('a[rel=searchCustomers]').on 'click', ->
    $('div.customerSearch').toggle()

  # Add a new attribute to a table
  $('a[data-behavior=addAttributeToAttributesTable]').on 'click', ->
    table = $('table.productAttributes')
    if $('tbody tr', table).length == 1 || $('tbody tr:last td:first input', table).val().length > 0
      template = $('tr.template', table).html()
      table.append("<tr>#{template}</tr>")
    false

  # Remove an attribute from a table
  $('table.productAttributes tbody').on 'click', 'tr td.remove a', ->
    $(this).parents('tr').remove()
    false

  # Sorting on the product attribtues table
  $('table.productAttributes tbody').sortable
    axis: 'y'
    handle: '.handle'
    cursor: 'move',
    helper: (e,tr)->
      originals = tr.children()
      helper = tr.clone()
      helper.children().each (index)->
        $(this).width(originals.eq(index).width())
      helper

  $('a[data-behavior=addAttachmentToExtraAttachments]').on 'click', (event) ->
    event.preventDefault();
    $('div.extraAttachments').show();
    $(this).hide();

  # Chosen
  $('select.chosen').chosen()
  $('select.chosen-with-deselect').chosen({allow_single_deselect: true})
  $('select.chosen-basic').chosen({disable_search_threshold:100})

  # Printables
  $('a[rel=print]').on 'click', ->
    window.open($(this).attr('href'), 'despatchnote', 'width=700,height=800')
    false

  # Close dialog
  $('body').on 'click', 'a[rel=closeDialog]', Nifty.Dialog.closeTopDialog

# Open AJAX dialogs
  $('body').on 'click','.stock-dialog a[rel=dialog]', ->

    element = $(this)
    options = {}
    options.width = element.data('dialog-width') if element.data('dialog-width')
    options.offset = element.data('dialog-offset') if element.data('dialog-offset')
    options.behavior = element.data('dialog-behavior') if element.data('dialog-behavior')
    options.html = element.data('html') if element.data('html')
    options.id = 'ajax'

    options.url = element.attr('href')

    Nifty.Dialog.open(options)
    false

# Format money values to 2 decimal places
  $('div.moneyInput input').each formatMoneyField
  $('body').on('blur', 'div.moneyInput input', formatMoneyField)

# areas dialog
  #点击箭头
  $('body').on 'click','.dialog-areas .gareas img',->
    $(".dialog-areas .showCityPop").not($(this).parents(".showCityPop:first")).removeClass("showCityPop")
    element = $(this).parent();
    element.parent().toggleClass('showCityPop')
  #点击全选
  $('body').on 'click','.dialog-areas .gareas input',->
    element = $(this).parent();
    checked = element.children("input:first").is(':checked')
    element.siblings(".citys").find(".areas input").prop("checked",checked)
    if $(this).is(':checked')
      childInputSize = element.siblings(".citys").find(".areas input").size()
      $(this).siblings("span:first").text("("+childInputSize+")")
    else
      $(this).siblings("span:first").text("("+0+")")
  #当每一个input 点击的时候
  $('body').on 'change','.dialog-areas .citys input',->
    console.log($(this).parents(".citys:first").find("input:checked").size())
    size = $(this).parents(".citys:first").find("input:checked").size()
    $(this).parents(".citys:first").siblings(".gareas:first").find("span").text("("+size+")")

  #当点击关闭的时候
  $('body').on 'click','.dialog-areas .citys p',->
    $(this).parents(".showCityPop").removeClass("showCityPop")

  #点击确定的时候
  $('body').on 'click','.dialog-areas .confirm',->
#    Nifty.Dialog.closeTopDialog
    ids = ($(".niftyDialog .dialog-areas .areas input:checked").map ->
      $(this).val()
    ).get().join(",")

    names = ($(".niftyDialog .dialog-areas .areas input:checked").map ->
      $(this).siblings("label:first").text()
    ).get().join(",")

    $(".areas-dialog a[rel=dialog][class*=dialog-popup]").parent().siblings('p:first').text(names)
    $(".areas-dialog a[rel=dialog][class*=dialog-popup]").siblings('input:last').val(names)
    $(".areas-dialog a[rel=dialog][class*=dialog-popup]").siblings("input:first").val(ids)
    $('.niftyDialog ').data('closeAction').call()


  # 点击编辑的时候
  $('body').on 'click','.areas-dialog a[rel=dialog]', ->

    $(".dialog-areas input").prop(checked: false)

    #从dom中拿出已经checked的id
    checkedArr = []
    thisDomArr = $(this).siblings("input").val().split(',')
    $(".areas-dialog input").each ->
      arr = thisDomArr
      for str in arr
        checkedArr.push(str)

    #先要checked 所有都input
    $(".dialog-areas input").each ->
      if($(this).val() in checkedArr)
        $(this).prop(checked: true)

    #如果子input checked 那么父级就要checked
    $(".dialog-areas .ecity").each ->
      citys = $(".citys",$(this))
      checkedSize = $("input:checked",citys).size()
      $(".gareas span",$(this)).text("("+checkedSize+")")

      if  checkedSize == $(".areas input",citys).size()
        $(this).find(".gareas input").prop(checked: true)


    $('a[rel=dialog]').not($(this)).removeClass('dialog-popup');
    $(this).addClass('dialog-popup');
    element = $(this)
    options = {}
    options.width = element.data('dialog-width') if element.data('dialog-width')
    options.offset = element.data('dialog-offset') if element.data('dialog-offset')
    options.behavior = element.data('dialog-behavior') if element.data('dialog-behavior')
    options.html = element.data('html') if element.data('html')
    options.id = 'ajax'

    html = $('.dialog-areas').clone()

    options.html = html.show()

    Nifty.Dialog.open(options)
    false

#
# Format money values to 2 decimal places
#
window.formatMoneyField = ->
  value = $(this).val().replace /,/, ""
  $(this).val(parseFloat(value).toFixed(2)) if value.length

#
# Stock Level Adjustment dialog beavior
#
Nifty.Dialog.addBehavior
  name: 'stockLevelAdjustments'
  onLoad: (dialog,options)->
    $('input[type=text]:first', dialog).focus()
    $(dialog).on 'submit', 'form', ->
      form = $(this)
      $.ajax
        url: form.attr('action')
        method: 'POST'
        data: form.serialize()
        dataType: 'text'
        success: (data)->
          $('div.table', dialog).replaceWith(data)
          $('input[type=text]:first', dialog).focus()
        error: (xhr)->
          if xhr.status == 422
            alert xhr.responseText
          else
            alert 'An error occurred while saving the stock level.'
      false
    $(dialog).on 'click', 'nav.pagination a', ->
      $.ajax
        url: $(this).attr('href')
        success: (data)->
          $('div.table', dialog).replaceWith(data)
      false

#
# Always fire keyboard shortcuts when focused on fields
#
Mousetrap.stopCallback = -> false

#
# Close dialogs on escape
#
Mousetrap.bind 'escape', ->
  Nifty.Dialog.closeTopDialog()
  false
  
