/**
 * Copyright (c) 2009 - 2012 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation.
 */
package org.candlepin.resteasy;

import org.candlepin.model.ResultIterator;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.StreamingOutput;



/**
 * The IterableStreamingOutput class provides a simple implementation for streaming the contents of
 * an iterable collection to clients. Resources can use this to reduce boilerplate code, turning a
 * 10-line block (not including required imports) into a one-line statement:
 * <pre>
 *   return Response.ok(new IterableStreamingOutput(iterable)).build();
 * </pre>
 *
 * If a ResultIterator is provided, it will automatically be closed once all elements have been
 * written to the underlying output stream.
 *
 * @param <T>
 *  The type to be streamed by this output streamer
 */
public class IterableStreamingOutput<T> implements StreamingOutput {

    protected JsonProvider jsonProvider;
    protected ObjectMapper mapper;
    protected Iterator<T> iterator;

    /**
     * Creates a new IterableStreamingOutput using the given iterable collection as its data source
     * to stream to the client.
     *
     * @param iterable
     *  The interable collection containing the data to stream to the client
     */
    public IterableStreamingOutput(Iterable<T> iterable) {
        this(iterable.iterator());
    }

    /**
     * Creates a new IterableStreamingOutput using the given iterator as its data source to stream
     * to the client.
     *
     * @param iterator
     *  The iterator containing the data to stream to the client
     *
     * @throws IllegalArgumentException
     *  if iterator is null
     */
    public IterableStreamingOutput(Iterator<T> iterator) {
        if (iterator == null) {
            throw new IllegalArgumentException("iterator is null");
        }

        this.jsonProvider = JsonProvider.getRegisteredInstance();
        if (this.jsonProvider == null) {
            // Hrmm... this shouldn't happen, but it might, so... I guess just make a new instance
            // and hope for the best...?
            this.jsonProvider = new JsonProvider(true);
        }

        this.mapper = this.jsonProvider.locateMapper(Object.class, MediaType.APPLICATION_JSON_TYPE);
        this.iterator = iterator;
    }

    @Override
    public void write(OutputStream stream) throws IOException, WebApplicationException {
        JsonGenerator generator = this.mapper.getJsonFactory().createGenerator(stream);
        generator.writeStartArray();

        while (this.iterator.hasNext()) {
            this.mapper.writeValue(generator, this.transform(this.iterator.next()));
        }

        generator.writeEndArray();
        generator.flush();
        generator.close();

        if (this.iterator instanceof ResultIterator) {
            ((ResultIterator) this.iterator).close();
        }
    }

    /**
     * Transforms the element before it is written to the output stream. This method is called once
     * for each element in the backing iterator.
     * <p/>
     * The default implementation provides no transformation and simply returns the input value
     * as given. Subclasses needing to transform elements in the iterator should override this
     * method instead of overriding the write() method.
     *
     * @param element
     *  The element to transform
     *
     * @return
     *  The transformed element to write to the output stream.
     */
    public Object transform(T element) {
        return element;
    }
}
