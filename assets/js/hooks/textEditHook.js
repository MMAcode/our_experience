import { LiveSocket } from "phoenix_live_view";
import Quill from "quill";

let toolbarOptions = [
  [{ header: [1, 2, false] }],
  ["bold", "italic", "underline", "strike", "blockquote"],
  [{ list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" }],
  ["link"], // ['link', 'image'],
  ["clean"],
];

let triggerJS = (querySelector) => {
  el = document.querySelector(querySelector);
  window.liveSocket.execJS(el, el.getAttribute("miro-js-to-trigger"));
};

console.log("miro - outside of mounted");
export let TextEditor = {
  mounted() {
    console.log("Miro - in Mounted");
    const sendChangesToServer = (quill, eventName, id = null) => {
      quill.on("text-change", (delta, oldDelta, source) => {
        if (source == "api") {
          console.log("An API call triggered this change.");
        } else if (source == "user") {
          // this.pushEventTo("#new_journal_entry", eventName, {
          this.pushEventTo("#my_journal_wrapper", eventName, {
            text_content: quill.getContents(),
            journalEntryId: id,
          });
        }
      });
    };

    let existingJEs = {};
    let deleteModalQuill;
    console.log("Miro Mounting text editor", this.el, this);

    // console.log('miroPost:', miroPost);

    let quill_newJE = new Quill(this.el, {
      modules: {
        toolbar: toolbarOptions,
      },
      theme: "snow",
    });

    sendChangesToServer(quill_newJE, "text-editor");

    // list existing JE
    window.addEventListener("phx:existingJournalEntryFromServer", (e) => {
      console.log(
        "new JE received, added to new quill, saved to quil List, JE id is: ",
        JSON.parse(e.detail.existingJE).id
      );
      let je = JSON.parse(e.detail.existingJE);
      let quill1 = new Quill(`#content_of_existing_journal_entry_id_${je.id}`, {
        readOnly: true,
      });
      quill1.setContents(je.content);
      existingJEs[je.id] = quill1;
      //   console.log("existingJEs", existingJEs);
    });

    // delete
    window.addEventListener(
      "phx:existingJournalEntryIdForDeleteModalFromServer",
      ({ detail: { id } }) => {
        console.log("id", id);
        // console.log("existingJEs", existingJEs[id].getText());
        deleteModalQuill = new Quill(
          "#modal_for_existing_journal_entry_to_delete .miroQuillContainer"
        );
        deleteModalQuill.enable(false);
        deleteModalQuill.setContents(existingJEs[id].getContents());

        document
          .querySelector(
            "#modal_for_existing_journal_entry_to_delete .confirm_action_button"
          )
          .setAttribute("phx-value-je_id_to_delete", id);

        triggerJS("#hiddenTriggerForViewingDeleteModal");
      }
    );

    // edit
    let quillForEditingModal = new Quill(
      "#modal_for_existing_journal_entry_to_edit .miroQuillContainer",
      {
        modules: {
          toolbar: toolbarOptions,
        },
        theme: "snow",
      }
    );
    window.addEventListener(
      "phx:existingJournalEntryIdForEditModalFromServer",
      ({ detail: { id } }) => {
        // console.log("id", id);

        quillForEditingModal.setContents(existingJEs[id].getContents());

        // console.log("editingQuiil text", quillForEditingModal.getText());

        document
          .querySelector(
            "#modal_for_existing_journal_entry_to_edit .confirm_action_button"
          )
          .setAttribute("phx-value-je_id_to_edit", id);

        triggerJS("#hiddenTriggerForViewingEditModal");
        sendChangesToServer(quillForEditingModal, "text-editor", id);
      }
    );
  },
  updated() {
    console.log("U");
  },
};
