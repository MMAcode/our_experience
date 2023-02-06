import Quill from "quill";

let toolbarOptions = [
  [{ header: [1, 2, false] }],
  ["bold", "italic", "underline", "strike", "blockquote"],
  [{ list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" }],
  ["link"], // ['link', 'image'],
  ["clean"],
];

export let TextEditor = {
  mounted() {
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

    // https://quilljs.com/docs/api/#setcontents
    // quill_newJE.setContents(delta: Delta, source: String = 'api'): Delta
    // dbData = { "ops": [{ "insert": "xx\n" }] }
    // quill_newJE.setContents(dbData)
    // quill_newJE.setContents({ "ops": [{ "insert": "xox\n" }] })

    quill_newJE.on("text-change", (delta, oldDelta, source) => {
      if (source == "api") {
        console.log("An API call triggered this change.");
      } else if (source == "user") {
        // this below works: (those above probably don't)
        // this.pushEvent("text-editor", { "text_content": quill_newJE.getContents() })
        this.pushEventTo("#new_journal_entry", "text-editor", {
          text_content: quill_newJE.getContents(),
        });
      }
    });

    window.addEventListener("phx:existingJournalEntryFromServer", (e) => {
      let je = JSON.parse(e.detail.existingJE);
      let quill1 = new Quill(`#content_of_existing_journal_entry_id_${je.id}`, {
        readOnly: true,
      });
      quill1.setContents(je.content);
      existingJEs[je.id] = quill1;
      //   console.log("existingJEs", existingJEs);
    });

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
            "#modal_for_existing_journal_entry_to_delete .miro_confirm_deleteJE"
          )
          .setAttribute("phx-value-je_id_to_delete", id);
      }
    );
  },
  updated() {
    console.log("U");
  },
};
