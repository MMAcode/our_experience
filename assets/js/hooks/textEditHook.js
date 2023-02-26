import { LiveSocket } from "phoenix_live_view";
import Quill from "quill";

let toolbarOptions = [
  [{ header: [1, 2, false] }],
  ["bold", "italic", "underline", "strike", "blockquote"],
  [{ list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" }],
  ["link"], // ['link', 'image'],
  ["clean"],
];

let triggerJSon = (querySelector) => {
  el = document.querySelector(querySelector);
  window.liveSocket.execJS(el, el.getAttribute("miro-js-to-trigger"));
};
quillContentSentToServerLastTimeAt = null;
console.log("miro - outside of mounted, NA HLAVU!!:-(");
export let TextEditor = {
  mounted() {
    let thisHook = this;
    console.log("Miro hook mounted, hook:", thisHook);

    let existingJEs = {};
    let currentlyEditedJEid;

    // console.log('miroPost:', miroPost);

    // let quill_newJE = new Quill(this.el, {
    console.log(document.querySelector("#editor_for_new_journal_entry"));
    let quill_newJE = new Quill("#editor_for_new_journal_entry", {
      modules: {
        toolbar: toolbarOptions,
      },
      theme: "snow",
    });
    console.log("quill_newJE", quill_newJE);

    let deleteModalQuill = new Quill(
      "#modal_for_existing_journal_entry_to_delete .miroQuillContainer"
    );

    let quillForEditingModal = new Quill(
      "#modal_for_existing_journal_entry_to_edit .miroQuillContainer",
      {
        modules: {
          toolbar: toolbarOptions,
        },
        theme: "snow",
      }
    );

    let defaultsavingInterval = 5;
    let pushToServer = (content, id) => {
      console.log("pushing to server", id, content);
      quillContentSentToServerLastTimeAt;
      timeNow = Date.now() / 1000;
      let difInSeconds = timeNow - quillContentSentToServerLastTimeAt;
      if (
        quillContentSentToServerLastTimeAt == null ||
        difInSeconds > defaultsavingInterval
      ) {
        thisHook.pushEventTo("#my_journal_wrapper", "text-editor", {
          text_content: content,
          journalEntryId: id,
        });
      }
    };

    quill_newJE.on("text-change", (delta, oldDelta, source) => {
      pushToServer(quill_newJE.getContents(), null);
    });

    quillForEditingModal.on("text-change", (delta, oldDelta, source) => {
      pushToServer(quillForEditingModal.getContents(), currentlyEditedJEid);
    });

    // activateSendingChangesToServer(quill_newJE, "text-editor");

    // list existing JE
    window.addEventListener("phx:existingJournalEntryFromServer", (e) => {
      console.log(
        "new JE received, added to new quill, saved to quil List, JE id is: ",
        JSON.parse(e.detail.existingJE).id
      );
      let je = JSON.parse(e.detail.existingJE);
      existingJEs[je.id] = new Quill(
        `#content_of_existing_journal_entry_id_${je.id}`,
        {
          readOnly: true,
        }
      );
      existingJEs[je.id].setContents(je.content);
      //   console.log("existingJEs", existingJEs);
    });

    // delete
    window.addEventListener(
      "phx:existingJournalEntryIdForDeleteModalFromServer",
      ({ detail: { id } }) => {
        console.log("id", id);
        // console.log("existingJEs", existingJEs[id].getText());
        deleteModalQuill.setContents(existingJEs[id].getContents());
        deleteModalQuill.enable(false);

        document
          .querySelector(
            "#modal_for_existing_journal_entry_to_delete .confirm_action_button"
          )
          .setAttribute("phx-value-je_id_to_delete", id);

        triggerJSon("#hiddenTriggerForViewingDeleteModal");
      }
    );

    // edit
    window.addEventListener(
      "phx:existingJournalEntryIdForEditModalFromServer",
      ({ detail: { id } } = e) => {
        console.log("quillForEditingModal", id, quillForEditingModal);
        currentlyEditedJEid = id;
        quillForEditingModal.setContents(existingJEs[id].getContents());
        // document
        //   .querySelector(
        //     "#modal_for_existing_journal_entry_to_edit .confirm_action_button"
        //   )
        //   .setAttribute("phx-value-je_id_to_edit", id);
        triggerJSon("#hiddenTriggerForViewingEditModal");
        // activateSendingChangesToServer(quillForEditingModal, "text-editor", id);
      }
    );

    // clear new
    window.addEventListener(
      "phx:existingJournalEntrySaved_clearContent",
      (e) => {
        console.log("clearning content of new JE quill");
        quill_newJE.setContents([]);
      }
    );

    window.addEventListener(
      "phx:setDefaultSavingInterval",
      ({ detail: { interval } } = e) => {
        console.log(
          "setting default saving interval from to: ",
          defaultsavingInterval,
          interval
        );
        defaultsavingInterval = interval;
      }
    );

    // getLatestQillDataOfNewQuill
    window.addEventListener("phx:getLatestQillDataOfNewQuill", (e) => {
      console.log("requesting latest content of new JE quill");
      thisHook.pushEventTo("#my_journal_wrapper", "text-editor", {
        text_content: quill_newJE.getContents(),
        journalEntryId: null,
      });
    });

    // getLatestQillDataOfEditedQuill
    window.addEventListener(
      "phx:getLatestQillDataOfEditedQuill",
      ({ detail: { id } } = e) => {
        // (e) => {
        console.log(
          "requesting latest content of edited JE quill with id: "
          // id,
          // quillForEditingModal.getContents(),
          // thisHook
        );

        thisHook.pushEventTo("#my_journal_wrapper", "text-editor", {
          text_content: quillForEditingModal.getContents(),
          // journalEntryId: id.toString(),
          journalEntryId: id,
        });
      }
    );
  },
  updated() {
    console.log("U");
  },
  error(e) {
    console.log("hook error captured:", e);
  },
};

//
// let afterXsecondsOfInactivityPushTo = (source, quillContent, id, delay) => {
//   if (source == "api") {
//     console.log("An API call triggered this change.");
//   } else if (source == "user") {
//     if (timer !== null) {
//       clearTimeout(timer);
//     }
//     timer = setTimeout(function () {
//       thisHook.pushEventTo("#my_journal_wrapper", "text-editor", {
//         text_content: quillContent,
//         journalEntryId: id,
//       });
//       timer = null;
//     }, delay);
//   }
// };
