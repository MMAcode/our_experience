import Quill from "quill";
export let TextEditor = {
  mounted() {
    console.log("Miro Mounting text editor", this.el, this);

    // console.log('miroPost:', miroPost);

    let quill_newJE = new Quill(this.el, {
      modules: {
        toolbar: [
          [{ header: [1, 2, false] }],
          ["bold", "italic", "underline", "strike", "blockquote"],
          [
            { list: "ordered" },
            { list: "bullet" },
            { indent: "-1" },
            { indent: "+1" },
          ],
          ["link"], // ['link', 'image'],
          ["clean"],
        ],
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
        //This sends the event of
        // def handle_event("text-editor", %{"text_content" => content}, socket) do
        // this.pushEventTo(this.el.phxHookId, "text-editor", {"text_content": quill.getContents()})

        // this below works: (those above probably don't)
        // this.pushEvent("text-editor", { "text_content": quill_newJE.getContents() })
        this.pushEventTo("#new_journal_entry", "text-editor", {
          text_content: quill_newJE.getContents(),
        });
      }
    });

    window.addEventListener("phx:existingJournalEntryFromServer", (e) => {
      let je = JSON.parse(e.detail.existingJE);
      let quill1 = new Quill(`#content_of_existing_journal_entry_id_${je.id}`);
      quill1.setContents(je.content);
    });
  },
  updated() {
    console.log("U");
  },
};
