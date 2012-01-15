/**
 * Created by JetBrains WebStorm.
 * User: simone
 * Date: 10/01/12
 * Time: 22:54
 * To change this template use File | Settings | File Templates.
 */


ko.bindingHandlers['mobileList'] = {
    'update': function (element, valueAccessor) {
        setTimeout(function () { //To make sure the refresh fires after the DOM is updated
            $(element).listview('refresh');
        }, 0);
    }
}

ko.bindingHandlers['mobileNewList'] = {
    'update': function (element, valueAccessor) {
        setTimeout(function () { //To make sure the refresh fires after the DOM is updated
            $(element).listview();
                    setTimeout(function () { //To make sure the refresh fires after the DOM is updated
            $(element).listview('refresh');
        }, 0);
        }, 0);
    }
}

ko.bindingHandlers['mobileWith'] = {

    'init': function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        return ko.bindingHandlers["with"].init(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);
    },
    'update': function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var t = ko.bindingHandlers["with"].update(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);
        setTimeout(function () {
            $(element).trigger("pagecreate"); //fixes un-enhanced issues
        }, 0);
        return t;
    }

};